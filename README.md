# Configuring the Database

```
cd config
cp postgres.docker.env.template postgres.docker.env
```

Open postgres.docker.env and change the POSTGRES_PASSWORD

# Starting the Container and Database

```
cd docker
./up.sh
```

# Stopping the Container and Database

```
cd docker
./down.sh
```

# Loading the SQL dump of the original database

Note: the docker/host_mnt directory is mounted by the container
and is available within the container as /host_mnt. This is the place
to put any scripts or data that you will need within the container.

```
cd docker
./connectToContainer.sh
```
As root in the container
```
cd /host_mnt/
su postgres
./restore-hazmit.sh <Path in container to the compressed SQL backup>
``` 

# Creating the `static_hazmit_readonly user`

1. Create a copy of the createReadOnlyUser.sql.template script
```
cd docker/host_mnt
cp createReadOnlyUser.sql.template createReadOnlyUser.sql
```

2. Open createReadOnlyUser.sql in an editor and modify the password in the following line:
```
CREATE ROLE static_hazmit_readonly LOGIN ENCRYPTED PASSWORD 'CHANGE THIS';
```

3. Connect to the container
```
cd ..
./connectToContainer.sh
```

4. Create the read-only user

as root within the container
```
su postgres
psql static_hazard_mitigation
```

You should now be connected to the database as postgres in the psql shell.
Execute the createReadOnlyUser SQL script.

```
\i /host_mnt/createReadOnlyUser.sql
```

# Configure remote access to the database

1. Open `docker/pgdata/pg_hba.conf`

2. Comment out the following line at the bottom of the file:

```
host all all all md5
```

3. Add the following line at the bottom of the file:

```
host    all     static_hazmit_readonly  0.0.0.0/0       md5
```

4. Restart the container

```
cd docker/
./down.sh
./up.sh
```
