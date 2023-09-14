"""Connect to an existings PostgreSQL database."""
import os
import psycopg
import pandas as pd
from contextlib import contextmanager
from dotenv import load_dotenv
from typing import Iterator
from sqlalchemy import create_engine


load_dotenv()

# Databse settings
USER = os.environ.get('USER')
PASSWORD =  os.environ.get('PASSWORD')
HOST = os.environ.get('HOST')
PORT = os.environ.get('PORT')
DBNAME = os.environ.get('DBNAME')


class DatabaseConnection:
    """Connect to a PostgreSQL database."""

    def __init__(
        self,
        user: str = os.environ.get('USER'),
        password: str =  os.environ.get('PASSWORD'),
        host: str =  os.environ.get('HOST'),
        port: str =  os.environ.get('PORT'),
        dbname: str = os.environ.get('DBNAME')
    ) -> None:
        """Create a connection string URI from dot-env file/ or params.

        Keyword arguments:
            user -- PostgreSQL user name to connect as.
            password -- password to be used if the server demands it.
            host -- name of host to connect to.
            port -- port number to connect to at the server host.
            dbname -- the database name.

        """
        self._uri = f'postgresql+psycopg://{user}:{password}@{host}:{port}/{dbname}'
        self._engine = create_engine(self._uri)

    @contextmanager
    def cursor(self) -> Iterator[psycopg.Cursor]:
        """Create a managed PostgreSQL database cursor.

        Yields:
            psycopg.Cursor -- a PostgreSQL cursor.
        """
        _conn = self._engine.raw_connection()
        cur = _conn.cursor()
        try:
            yield cur
        except (Exception) as e:
            _conn.rollback()
            print(e)
        else:
            _conn.commit()
        finally:
            cur.close()
            _conn.close()

    def query(self, db_query: str) -> None:
        """Query into a PostgreSQL database.

        Keyword arguments:
            db_query -- sql query to be executed.
        """
        with self.cursor() as cur:
            cur.execute(db_query)

    def query_file(self, file_path: str) -> None:
        """Query from file into a PostgreSQL database.

        Keyword arguments:
            file_path -- relative path to a sql file.
        """
        with open(file_path, mode='r', encoding='utf-8') as query:
            self.query(query.read())

    def fetch(self, db_query: str) -> pd.DataFrame:
        """Fetch data from a PostgreSQL database.

        Keyword arguments:
            db_query -- sql query to be executed.
        Yields:
            pd.DataFrame -- data is stored in a Pandas dataframe.
        """
        return pd.read_sql_query(db_query, self._engine.connect())

    def fetch_file(self, file_path: str) -> pd.DataFrame:
        """Fetch data from a PostgreSQL database with a sql file.

        Keyword arguments:
            file_path -- relative path to a sql file.
        Yields:
            pd.Dataframe -- data is stored in a Pandas dataframe.
        """
        with open(file_path, mode='r', encoding='utf-8') as query:
            return self.fetch(query.read())

    def __str__(self) -> str:
        """Return connectiong string URI."""
        return f'{self._uri}'

# TODO:

    def switch_db(self) -> None:
        """Rename the connection str to PostgreSQL database."""
        pass

    def fetch_table(self, table: str) -> pd.DataFrame:
        """Fetch table data from connected databse.

        Yields:
            pd.Dataframe -- data is stored in a Pandas dataframe.
        """
        pass


if __name__ == "__main__":
    # Display the PostgreSQL database server version
    db = DatabaseConnection()
    with db.cursor() as cur:
        cur.execute("""SELECT version();""")
        db_version = cur.fetchone()
        print(db_version)
