rstudioapi::restartSession()

rsconnect::setAccountInfo(
  name   = 'kalimu',
  token  = Sys.getenv("SHINYAPPSIO_TOKEN"),
  secret = Sys.getenv("SHINYAPPSIO_SECRET")
)

# pak::pkg_install("r-world-devs/GitAI")

rsconnect::deployApp(
  appDir = "inst/demo",
  account = "kalimu", 
  appName = "GitAI-demo"
)

# https://kalimu.shinyapps.io/GitAI-demo/