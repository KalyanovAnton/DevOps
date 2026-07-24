# Базовий образ Python
FROM python:3.10-slim

# Встановлюємо робочу директорію всередині контейнера
WORKDIR /app

# Забороняємо Python писати файли .pyc на диск
ENV PYTHONDONTWRITEBYTECODE 1
# Забороняємо Python буферизувати stdout та stderr (для чистих логів)
ENV PYTHONUNBUFFERED 1

# Копіюємо і встановлюємо залежності
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо весь код проєкту в контейнер
COPY . /app/

# Запускати будемо через gunicorn на порту 8000 (проєкт назвемо core)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "core.wsgi:application"]