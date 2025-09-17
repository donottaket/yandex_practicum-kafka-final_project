#!/usr/bin/env bash

DAYS_CA=3650
DAYS_LEAF=825
KEY_BITS=4096

OUT_DIR=/workspace/certificates

CA_CNF=/workspace/configurations/root/ca.cnf
NODES_CNF_DIR=/workspace/configurations/nodes

mkdir -p "$OUT_DIR"
mkdir -p "$OUT_DIR/client_cli"

openssl req -new -x509 -sha256 -days "$DAYS_CA" \
  -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/ca.key" \
  -out "$OUT_DIR/ca.crt" -config "$CA_CNF"

# kafka_0_controller_0 -------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_0_controller_0.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_0_controller_0.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-0-controller-0" \
  -out "$OUT_DIR/kafka_0_controller_0.p12" \
  -passout "pass:${KAFKA_0_CONTROLLER_0_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_0_controller_0.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_0_CONTROLLER_0_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_0_controller_0.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_0_CONTROLLER_0_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_0_CONTROLLER_0_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_0_controller_0.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_0_controller_0.trust_store.jks" -storetype JKS -storepass "${KAFKA_0_CONTROLLER_0_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_0_controller_1 -------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_0_controller_1.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_0_controller_1.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-0-controller-1" \
  -out "$OUT_DIR/kafka_0_controller_1.p12" \
  -passout "pass:${KAFKA_0_CONTROLLER_1_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_0_controller_1.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_0_CONTROLLER_1_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_0_controller_1.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_0_CONTROLLER_1_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_0_CONTROLLER_1_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_0_controller_1.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_0_controller_1.trust_store.jks" -storetype JKS -storepass "${KAFKA_0_CONTROLLER_1_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_0_controller_2 -------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_0_controller_2.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_0_controller_2.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-0-controller-2" \
  -out "$OUT_DIR/kafka_0_controller_2.p12" \
  -passout "pass:${KAFKA_0_CONTROLLER_2_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_0_controller_2.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_0_CONTROLLER_2_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_0_controller_2.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_0_CONTROLLER_2_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_0_CONTROLLER_2_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_0_controller_2.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_0_controller_2.trust_store.jks" -storetype JKS -storepass "${KAFKA_0_CONTROLLER_2_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_1_controller_0 -------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_1_controller_0.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_1_controller_0.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-1-controller-0" \
  -out "$OUT_DIR/kafka_1_controller_0.p12" \
  -passout "pass:${KAFKA_1_CONTROLLER_0_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_1_controller_0.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_1_CONTROLLER_0_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_1_controller_0.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_1_CONTROLLER_0_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_1_CONTROLLER_0_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_1_controller_0.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_1_controller_0.trust_store.jks" -storetype JKS -storepass "${KAFKA_1_CONTROLLER_0_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_1_controller_1 -------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_1_controller_1.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_1_controller_1.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-1-controller-1" \
  -out "$OUT_DIR/kafka_1_controller_1.p12" \
  -passout "pass:${KAFKA_1_CONTROLLER_1_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_1_controller_1.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_1_CONTROLLER_1_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_1_controller_1.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_1_CONTROLLER_1_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_1_CONTROLLER_1_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_1_controller_1.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_1_controller_1.trust_store.jks" -storetype JKS -storepass "${KAFKA_1_CONTROLLER_1_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_1_controller_2 -------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_1_controller_2.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_1_controller_2.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-1-controller-2" \
  -out "$OUT_DIR/kafka_1_controller_2.p12" \
  -passout "pass:${KAFKA_1_CONTROLLER_2_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_1_controller_2.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_1_CONTROLLER_2_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_1_controller_2.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_1_CONTROLLER_2_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_1_CONTROLLER_2_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_1_controller_2.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_1_controller_2.trust_store.jks" -storetype JKS -storepass "${KAFKA_1_CONTROLLER_2_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_0_broker_0 -----------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_0_broker_0.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_0_broker_0.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-0-broker-0" \
  -out "$OUT_DIR/kafka_0_broker_0.p12" \
  -passout "pass:${KAFKA_0_BROKER_0_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_0_broker_0.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_0_BROKER_0_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_0_broker_0.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_0_BROKER_0_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_0_BROKER_0_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_0_broker_0.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_0_broker_0.trust_store.jks" -storetype JKS -storepass "${KAFKA_0_BROKER_0_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_0_broker_1 -----------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_0_broker_1.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_0_broker_1.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-0-broker-1" \
  -out "$OUT_DIR/kafka_0_broker_1.p12" \
  -passout "pass:${KAFKA_0_BROKER_1_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_0_broker_1.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_0_BROKER_1_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_0_broker_1.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_0_BROKER_1_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_0_BROKER_1_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_0_broker_1.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_0_broker_1.trust_store.jks" -storetype JKS -storepass "${KAFKA_0_BROKER_1_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_0_broker_2 -----------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_0_broker_2.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_0_broker_2.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-0-broker-2" \
  -out "$OUT_DIR/kafka_0_broker_2.p12" \
  -passout "pass:${KAFKA_0_BROKER_2_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_0_broker_2.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_0_BROKER_2_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_0_broker_2.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_0_BROKER_2_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_0_BROKER_2_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_0_broker_2.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_0_broker_2.trust_store.jks" -storetype JKS -storepass "${KAFKA_0_BROKER_2_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_1_broker_0 -----------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_1_broker_0.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_1_broker_0.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-1-broker-0" \
  -out "$OUT_DIR/kafka_1_broker_0.p12" \
  -passout "pass:${KAFKA_1_BROKER_0_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_1_broker_0.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_1_BROKER_0_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_1_broker_0.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_1_BROKER_0_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_1_BROKER_0_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_1_broker_0.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_1_broker_0.trust_store.jks" -storetype JKS -storepass "${KAFKA_1_BROKER_0_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_1_broker_1 -----------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_1_broker_1.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_1_broker_1.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-1-broker-1" \
  -out "$OUT_DIR/kafka_1_broker_1.p12" \
  -passout "pass:${KAFKA_1_BROKER_1_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_1_broker_1.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_1_BROKER_1_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_1_broker_1.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_1_BROKER_1_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_1_BROKER_1_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_1_broker_1.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_1_broker_1.trust_store.jks" -storetype JKS -storepass "${KAFKA_1_BROKER_1_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_1_broker_2 -----------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_1_broker_2.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_1_broker_2.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-1-broker-2" \
  -out "$OUT_DIR/kafka_1_broker_2.p12" \
  -passout "pass:${KAFKA_1_BROKER_2_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_1_broker_2.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_1_BROKER_2_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_1_broker_2.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_1_BROKER_2_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_1_BROKER_2_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_1_broker_2.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_1_broker_2.trust_store.jks" -storetype JKS -storepass "${KAFKA_1_BROKER_2_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_0_acl ----------------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_0_acl.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_0_acl.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-0-acl" \
  -out "$OUT_DIR/kafka_0_acl.p12" \
  -passout "pass:${KAFKA_0_ACL_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_0_acl.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_0_ACL_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_0_acl.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_0_ACL_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_0_ACL_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_0_acl.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_0_acl.trust_store.jks" -storetype JKS -storepass "${KAFKA_0_ACL_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_1_acl
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_1_acl.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_1_acl.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-1-acl" \
  -out "$OUT_DIR/kafka_1_acl.p12" \
  -passout "pass:${KAFKA_1_ACL_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_1_acl.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_1_ACL_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_1_acl.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_1_ACL_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_1_ACL_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_1_acl.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_1_acl.trust_store.jks" -storetype JKS -storepass "${KAFKA_1_ACL_SSL_TRUST_STORE_PASSWORD}" -noprompt

# schema_registry ------------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/schema_registry.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/schema_registry.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "schema-registry" \
  -out "$OUT_DIR/schema_registry.p12" \
  -passout "pass:${SCHEMA_REGISTRY_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/schema_registry.p12" -srcstoretype PKCS12 -srcstorepass "${SCHEMA_REGISTRY_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/schema_registry.key_store.jks" -deststoretype JKS -deststorepass "${SCHEMA_REGISTRY_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${SCHEMA_REGISTRY_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/schema_registry.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/schema_registry.trust_store.jks" -storetype JKS -storepass "${SCHEMA_REGISTRY_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_connect --------------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_connect.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_connect.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-connect" \
  -out "$OUT_DIR/kafka_connect.p12" \
  -passout "pass:${KAFKA_CONNECT_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_connect.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_CONNECT_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_connect.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_CONNECT_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_CONNECT_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_connect.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_connect.trust_store.jks" -storetype JKS -storepass "${KAFKA_CONNECT_SSL_TRUST_STORE_PASSWORD}" -noprompt

# ksql_db --------------------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/ksql_db.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/ksql_db.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "ksql-db" \
  -out "$OUT_DIR/ksql_db.p12" \
  -passout "pass:${KSQL_DB_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/ksql_db.p12" -srcstoretype PKCS12 -srcstorepass "${KSQL_DB_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/ksql_db.key_store.jks" -deststoretype JKS -deststorepass "${KSQL_DB_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KSQL_DB_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/ksql_db.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/ksql_db.trust_store.jks" -storetype JKS -storepass "${KSQL_DB_SSL_TRUST_STORE_PASSWORD}" -noprompt

# shop -----------------------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/shop.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/shop.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "shop" \
  -out "$OUT_DIR/shop.p12" \
  -passout "pass:${SHOP_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/shop.p12" -srcstoretype PKCS12 -srcstorepass "${SHOP_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/shop.key_store.jks" -deststoretype JKS -deststorepass "${SHOP_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${SHOP_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/shop.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/shop.trust_store.jks" -storetype JKS -storepass "${SHOP_SSL_TRUST_STORE_PASSWORD}" -noprompt

# product_filter -------------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/product_filter.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/product_filter.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "product-filter" \
  -out "$OUT_DIR/product_filter.p12" \
  -passout "pass:${PRODUCT_FILTER_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/product_filter.p12" -srcstoretype PKCS12 -srcstorepass "${PRODUCT_FILTER_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/product_filter.key_store.jks" -deststoretype JKS -deststorepass "${PRODUCT_FILTER_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${PRODUCT_FILTER_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/product_filter.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/product_filter.trust_store.jks" -storetype JKS -storepass "${PRODUCT_FILTER_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_ui -------------------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_ui.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_ui.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-ui" \
  -out "$OUT_DIR/kafka_ui.p12" \
  -passout "pass:${KAFKA_UI_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_ui.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_UI_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_ui.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_UI_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_UI_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_ui.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_ui.trust_store.jks" -storetype JKS -storepass "${KAFKA_UI_SSL_TRUST_STORE_PASSWORD}" -noprompt

# kafka_connect_mirroring ----------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/kafka_connect_mirroring.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/kafka_connect_mirroring.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "kafka-connect-mirroring" \
  -out "$OUT_DIR/kafka_connect_mirroring.p12" \
  -passout "pass:${KAFKA_CONNECT_MIRRORING_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/kafka_connect_mirroring.p12" -srcstoretype PKCS12 -srcstorepass "${KAFKA_CONNECT_MIRRORING_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/kafka_connect_mirroring.key_store.jks" -deststoretype JKS -deststorepass "${KAFKA_CONNECT_MIRRORING_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${KAFKA_CONNECT_MIRRORING_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/kafka_connect_mirroring.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/kafka_connect_mirroring.trust_store.jks" -storetype JKS -storepass "${KAFKA_CONNECT_MIRRORING_SSL_TRUST_STORE_PASSWORD}" -noprompt

# nifi -----------------------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/nifi.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/nifi.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "nifi" \
  -out "$OUT_DIR/nifi.p12" \
  -passout "pass:${NIFI_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/nifi.p12" -srcstoretype PKCS12 -srcstorepass "${NIFI_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/nifi.key_store.jks" -deststoretype JKS -deststorepass "${NIFI_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${NIFI_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/nifi.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/nifi.trust_store.jks" -storetype JKS -storepass "${NIFI_SSL_TRUST_STORE_PASSWORD}" -noprompt

# client ---------------------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/tls.key" -out "$OUT_DIR/tls.csr" -config "$NODES_CNF_DIR/client.cnf"

openssl x509 -req -in "$OUT_DIR/tls.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/tls.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/client.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/tls.crt" -inkey "$OUT_DIR/tls.key" \
  -certfile "$OUT_DIR/ca.crt" \
  -name "client" \
  -out "$OUT_DIR/client.p12" \
  -passout "pass:${CLIENT_SSL_KEY_PASSWORD}"

keytool -importkeystore \
  -srckeystore "$OUT_DIR/client.p12" -srcstoretype PKCS12 -srcstorepass "${CLIENT_SSL_KEY_PASSWORD}" \
  -destkeystore "$OUT_DIR/client.key_store.jks" -deststoretype JKS -deststorepass "${CLIENT_SSL_KEY_STORE_PASSWORD}" \
  -destkeypass "${CLIENT_SSL_KEY_PASSWORD}"

rm -f "$OUT_DIR/tls.key" "$OUT_DIR/tls.crt" "$OUT_DIR/client.p12" "$OUT_DIR/tls.csr"

keytool -importcert -alias local-ca \
  -file "$OUT_DIR/ca.crt" \
  -keystore "$OUT_DIR/client.trust_store.jks" -storetype JKS -storepass "${CLIENT_SSL_TRUST_STORE_PASSWORD}" -noprompt

# client-cli -----------------------------------------------------------------------------------------------------------
openssl req -new -newkey "rsa:$KEY_BITS" -nodes \
  -keyout "$OUT_DIR/client_cli/client_cli.key" -out "$OUT_DIR/client_cli/client_cli.csr" -config "$NODES_CNF_DIR/client_cli.cnf"

openssl x509 -req -in "$OUT_DIR/client_cli/client_cli.csr" \
  -CA "$OUT_DIR/ca.crt" -CAkey "$OUT_DIR/ca.key" -CAcreateserial \
  -out "$OUT_DIR/client_cli/client_cli.crt" -days "$DAYS_LEAF" -sha256 \
  -extfile "$NODES_CNF_DIR/client_cli.cnf" -extensions v3_req

openssl pkcs12 -export \
  -in "$OUT_DIR/client_cli/client_cli.crt" -inkey "$OUT_DIR/client_cli/client_cli.key" -certfile "$OUT_DIR/ca.crt" \
  -name "client-cli" -out "$OUT_DIR/client_cli/client_cli.p12" -passout "pass:${CLIENT_CLI_SSL_KEY_PASSWORD}"