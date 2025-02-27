# Testing stage using a Python 2.7 container
FROM python:2.7
WORKDIR /tests

# Install necessary Python packages
RUN pip install requests

# Copy end-to-end tests into the container
COPY  . /tests

# Use entrypoint to run the tests
ENTRYPOINT ["python", "e2e_test.py"]
