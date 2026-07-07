import os
from contextlib import contextmanager

from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

Base = declarative_base()

_engine = None
_SessionLocal = None


def get_database_url():
    database_url = (
        os.getenv('PANNEAU_DATABASE_URL') or os.getenv('DATABASE_URL')
    )
    if database_url:
        return database_url

    return (
        'postgresql+psycopg2://postgres:postgres@localhost:5432/'
        'PanneauSolaireDB'
    )


def get_engine():
    global _engine, _SessionLocal

    if _engine is not None:
        return _engine

    database_url = get_database_url()
    if not database_url:
        raise RuntimeError(
            "Aucune base configuree. Definis PANNEAU_DATABASE_URL ou DATABASE_URL."
        )

    _engine = create_engine(database_url)
    _SessionLocal = sessionmaker(bind=_engine, expire_on_commit=False)
    return _engine


def get_session_factory():
    global _SessionLocal
    if _SessionLocal is None:
        get_engine()
    return _SessionLocal


@contextmanager
def session_scope():
    session = get_session_factory()()
    try:
        yield session
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()
