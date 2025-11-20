import csv
import os
from kafka import KafkaProducer


def main():
    bootstrap_servers = os.environ.get("KAFKA_BOOTSTRAP_SERVERS", "localhost:29092")
    topic = os.environ.get("KAFKA_TOPIC", "teta_transactions")
    csv_path = os.environ.get("CSV_PATH", "data/train.csv")

    producer = KafkaProducer(bootstrap_servers=bootstrap_servers)

    with open(csv_path, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        header = next(reader)

        for row in reader:
            line = ",".join(row)
            producer.send(topic, value=line.encode("utf-8"))

    producer.flush()
    producer.close()


if __name__ == "__main__":
    main()
