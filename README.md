# JPetStore (NeoLoad training)

The iBATIS JPetStore 4 demo (Struts 1, iBATIS 2, HSQLDB 1.8) from the NeoLoad training kit, packaged in Docker for free hosting on Render.

Differences from the local training setup (Tomcat 5.5 + Java 1.5 + separate HSQLDB server):

- Runs on Tomcat 9 + Java 8.
- The same HSQLDB database (`db/jpetstore.script`) runs inside the Tomcat JVM in file mode, so it fits in one 512 MB container. Only the `url` line in `WEB-INF/classes/properties/database.properties` changed.

## Deploy on Render (free)

**New → Web Service → Public Git Repository**, paste this repository's URL, keep **Docker**, choose **Free**, and deploy. The shop is then at `https://<service>.onrender.com/jpetstore/`.

The free instance sleeps after 15 minutes without traffic and takes about a minute to wake up. Its disk is not persistent: accounts and orders created during a session are lost when it restarts, and the database goes back to the copy in `db/`.

## Test accounts

`accounts.csv` lists the training accounts (`user1` / `pass1` and so on), ready to use as a NeoLoad variable file.

## Run locally

```
docker build -t jpetstore .
docker run -p 8084:8080 jpetstore
```

Then open http://localhost:8084/jpetstore/.
