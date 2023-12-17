import sentry_sdk

sentry_sdk.init(
    dsn="https://1084d4fe1e7aa7fc9825dfac48685487@o4506410472308736.ingest.sentry.io/4506410596564992",
    environment="development",
    release="1.0"
)

if __name__ == "__main__":
    division_zero = 1 / 0