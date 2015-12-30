# Netezza Dockerfile

This image includes unixODBC with a registered IBM Netezza driver.

## Build

Due to licensing this currently requires unpacking the Netezza driver locally into a directory called `netezza`.

To build the image, run:

```
docker build -t dbhi/netezza .
```

## Usage

The primary intent is to extend the image for applications that use an ODBC client library. For example:

```
FROM dbhi/netezza

...
```

Running the image as is will test the connection settings.

```sh
$ docker run --rm --env-file conn.env dbhi/netezza
Connection successful!
```

To customize the connection settings, set the following environment variables as options or in an [environment file](https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables-e-env-env-file).

- `NZ_HOST`
- `NZ_USER`
- `NZ_PASSWORD`
- `NZ_DATABASE`
- `NZ_DBMS_PORT` - *(this is not an error)*

### Run a query

To run a sample query, use the `nzodbcsql` command with the `-q` option to supply a query string. Note that this only for testing since it returns a maximum of 100 rows for the query.

```
docker run --rm -it --env-file=cdw.env dbhi/netezza nzodbcsql -q '...'
```

The `-f` option is also available for supplying a file. For this to work, mount a volume to the container containing the SQL file(s):

```
docker run --rm -it --env-file=cdw.env -v /path/to/sql:/sql dbhi/netezza nzodbcsql -f /sql/query.sql
```

## References

- [IBM documentation](http://www-01.ibm.com/support/knowledgecenter/SSULQD_7.2.0/com.ibm.nz.datacon.doc/t_datacon_installing_unix_64bit_client.html) for installing the client on a supported Linux host.
