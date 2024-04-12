# образ с python dockerhub
FROM python:3.11-slim as python-base

# name и email команды разработчиков.
LABEL maintainer="Karim Valiev <karim_valiev@mail.ru>"

# создаем рабочую папку в контейнере
WORKDIR /app

# https://python-poetry.org/docs#ci-recommendations
# Конфигурирование Poetry
# фиксируем версию, определяем каталог для установки, вирт окр., кэш
ENV POETRY_VERSION=1.2.0
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv
ENV POETRY_CACHE_DIR=/opt/.cache

# Create stage for Poetry installation
FROM python-base as poetry-base

# Устанавливаем poetry отдельно от глобального интерпретатора python
RUN python3 -m venv $POETRY_VENV \
	&& $POETRY_VENV/bin/pip install -U pip setuptools \
	&& $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}

# Добавляем poetry to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"

# Устанавливаем зависимости
# poetry.lock 
COPY pyproject.toml ./ 
RUN poetry install

# Run your app
COPY ./app/app.py ./

# ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--allow-root"]
# ENTRYPOINT ["python", "app.py"]
# CMD [ "poetry", "run", "python", "-c", "print('Hello, World!')" ]