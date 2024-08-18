import psycopg2

# Connect to your postgres DB
def getConnection():
  return psycopg2.connect(
  dbname = "bitofy",
  user = "postgres",
  password = "lipinho19",
  host = "localhost",
  port = 5432
  )
