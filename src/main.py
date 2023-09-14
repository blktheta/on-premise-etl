"""Script that creates/examines a data warehouse using PostgreSQL."""
import argparse


def main(mode: str) -> None:
    """Function to create the PostgreSQL datawarehouse.

    Keyword arguments:
        mode -- either build the data warehouse or showcase a report.
    """
    if mode == 'build':
        print("Build the data warehouse
    else:
        print("Examine the data warehouse")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Creates/Examines data warehouse.')

    parser.add_argument(
        '-m',
        '--mode',
        choices=['build', 'report'],
        default='report',
        type=str,
        help='Indicate which procedure to run.',
        required=True
    )

    args = parser.parse_args()
    main(mode=args.mode)
