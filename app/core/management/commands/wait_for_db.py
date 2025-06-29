"""
Django command to wait for the database to be ready.
"""

from django.core.management.base import BaseCommand

import time
from django.db.utils import OperationalError
from psycopg2 import OperationalError as Psycopg2Error


class Command(BaseCommand):
    """Django command to wait for the database to be ready."""

    def handle(self, *args, **options):
        """Handle the command."""
        self.stdout.write("Waiting for database...")
        db_up = False
        while not db_up:
            try:
                self.check(databases=["default"])
                db_up = True
            except (Psycopg2Error, OperationalError):
                self.stdout.write("Database not ready, waiting 1 second...")
                time.sleep(1)

        self.stdout.write(self.style.SUCCESS("Database is ready!"))
