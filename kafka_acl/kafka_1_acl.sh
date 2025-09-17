#!/usr/bin/env bash

KEY_PASSWORD="${KAFKA_1_ACL_KEY_PASSWORD}"
KEY_STORE_LOCATION="${KAFKA_1_ACL_KEY_STORE_LOCATION}"
KEY_STORE_PASSWORD="${KAFKA_1_ACL_KEY_STORE_PASSWORD}"
KEY_STORE_TYPE="${KAFKA_1_ACL_KEY_STORE_TYPE}"
TRUST_STORE_LOCATION="${KAFKA_1_ACL_TRUST_STORE_LOCATION}"
TRUST_STORE_PASSWORD="${KAFKA_1_ACL_TRUST_STORE_PASSWORD}"
TRUST_STORE_TYPE="${KAFKA_1_ACL_TRUST_STORE_TYPE}"

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

# ACNs for nifi
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:nifi" --group nifi \
  --operation READ
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:nifi" --topic client.search.result \
  --operation READ \
  --operation DESCRIBE
kafka-acls.sh --bootstrap-server "${BOOTSTRAP_SERVER}" --command-config "$PROPS" \
  --add --allow-principal "User:nifi" --topic shop.product \
  --operation READ \
  --operation DESCRIBE