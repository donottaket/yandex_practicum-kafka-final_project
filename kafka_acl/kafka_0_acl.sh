#!/usr/bin/env bash

KEY_PASSWORD="${KAFKA_0_ACL_KEY_PASSWORD}"
KEY_STORE_LOCATION="${KAFKA_0_ACL_KEY_STORE_LOCATION}"
KEY_STORE_PASSWORD="${KAFKA_0_ACL_KEY_STORE_PASSWORD}"
KEY_STORE_TYPE="${KAFKA_0_ACL_KEY_STORE_TYPE}"
TRUST_STORE_LOCATION="${KAFKA_0_ACL_TRUST_STORE_LOCATION}"
TRUST_STORE_PASSWORD="${KAFKA_0_ACL_TRUST_STORE_PASSWORD}"
TRUST_STORE_TYPE="${KAFKA_0_ACL_TRUST_STORE_TYPE}"

PROPS=/tmp/admin-ssl.properties

cat > "$PROPS" <<EOF
security.protocol=SSL
ssl.keystore.type=$KEY_STORE_TYPE
ssl.keystore.location=$KEY_STORE_LOCATION
ssl.keystore.password=$KEY_STORE_PASSWORD
ssl.key.password=$KEY_PASSWORD
ssl.truststore.type=$TRUST_STORE_TYPE
ssl.truststore.location=$TRUST_STORE_LOCATION
ssl.truststore.password=$TRUST_STORE_PASSWORD
EOF

export PATH=/opt/bitnami/kafka/bin:$PATH

# Create topics
kafka-topics.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --create --topic shop.product \
  --partitions 3 --replication-factor 3 --if-not-exists \
  --config cleanup.policy=compact \
  --config min.insync.replicas=2
kafka-topics.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --create --topic shop.product.filtered \
  --partitions 3 --replication-factor 3 --if-not-exists \
  --config cleanup.policy=compact \
  --config min.insync.replicas=2
kafka-topics.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --create --topic product.black-list \
  --partitions 3 --replication-factor 3 --if-not-exists \
  --config cleanup.policy=compact \
  --config min.insync.replicas=2
kafka-topics.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --create --topic schemas \
  --partitions 1 --replication-factor 3 --if-not-exists \
  --config cleanup.policy=compact \
  --config min.insync.replicas=2
kafka-topics.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --create --topic connect-config-storage \
  --partitions 1 --replication-factor 3 --if-not-exists \
  --config cleanup.policy=compact \
  --config min.insync.replicas=2
kafka-topics.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --create --topic connect-offset-storage \
  --partitions 25 --replication-factor 3 --if-not-exists \
  --config cleanup.policy=compact \
  --config min.insync.replicas=2
kafka-topics.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --create --topic connect-status-storage \
  --partitions 5 --replication-factor 3 --if-not-exists \
  --config cleanup.policy=compact \
  --config min.insync.replicas=2
kafka-topics.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --create --topic client.search.result \
  --partitions 3 --replication-factor 3 --if-not-exists \
  --config cleanup.policy=compact \
  --config min.insync.replicas=2

# ACLs for shop
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:shop" --topic shop.product \
  --operation WRITE \
  --operation DESCRIBE

# ACLs for client
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:client" --topic client.search.result \
  --operation WRITE \
  --operation DESCRIBE

# ACLs for schema-registry
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:schema-registry" --topic schemas \
  --operation WRITE \
  --operation DESCRIBE \
  --operation READ \
  --operation DESCRIBECONFIGS \
  --operation ALTER
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:schema-registry" --group schema-registry \
  --operation READ

# ACLs for product-filter
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:product-filter" --topic shop.product \
  --operation READ --operation DESCRIBE
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:product-filter" --topic shop.product.filtered \
  --operation WRITE \
  --operation DESCRIBE
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:product-filter" --topic product.black-list \
  --operation WRITE \
  --operation DESCRIBE \
  --operation READ
kafka-acls.sh --bootstrap-server "$BOOTSTRAP_SERVER" --command-config "$PROPS" \
  --add --allow-principal "User:product-filter" \
  --topic product-filter- --resource-pattern-type prefixed \
  --operation CREATE \
  --operation READ \
  --operation WRITE \
  --operation DESCRIBE
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:product-filter" --group product-filter \
  --operation READ \
  --operation DESCRIBE

# ACLs for kafka-connect
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:kafka-connect" --topic connect-config-storage \
  --operation READ \
  --operation WRITE \
  --operation DESCRIBE \
  --operation DESCRIBECONFIGS \
  --operation ALTER
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:kafka-connect" --topic connect-offset-storage \
  --operation READ \
  --operation WRITE \
  --operation DESCRIBE \
  --operation DESCRIBECONFIGS \
  --operation ALTER
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:kafka-connect" --topic connect-status-storage \
  --operation READ \
  --operation WRITE --operation DESCRIBE \
  --operation DESCRIBECONFIGS \
  --operation ALTER
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:kafka-connect" --topic shop.product.filtered \
  --operation READ \
  --operation DESCRIBE
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:kafka-connect" --group connect- \
  --resource-pattern-type prefixed --operation READ
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:kafka-connect" --group kafka-connect \
  --operation READ \
  --operation DESCRIBE