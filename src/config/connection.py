import psycopg2

# Conexão com DB postgres
def getConnection():
  return psycopg2.connect(
  dbname = "bitofy",
  user = "postgres",
  password = "lipinho19",
  host = "localhost",
  port = 5432
  )
