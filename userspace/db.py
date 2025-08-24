import psycopg2
import json
import time

class Database:
    def __init__(self, config_path='config.json'):
        self.conn = None
        try:
            with open(config_path, 'r') as f:
                config = json.load(f)
        except (FileNotFoundError, json.JSONDecodeError) as e:
            print(f"Error reading config file: {e}")
            raise

        retries = 5
        while retries > 0:
            try:
                self.conn = psycopg2.connect(
                    dbname=config.get("db_name"),
                    user=config.get("db_user"),
                    password=config.get("db_password"),
                    host=config.get("db_host"),
                    port=config.get("db_port")
                )
                print(f"Successfully connected to the database at {config.get('db_host')}.")
                break
            except psycopg2.OperationalError as e:
                print(f"Database connection failed: {e}. Retrying in 5 seconds...")
                retries -= 1
                time.sleep(5)
        
        if not self.conn:
            raise Exception("Could not connect to the database after several retries.")

    def setup_table(self):
        with self.conn.cursor() as cur:
            cur.execute("""
            CREATE TABLE IF NOT EXISTS firewall_logs (
                id SERIAL PRIMARY KEY,
                timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                machine_name VARCHAR(50),
                direction SMALLINT, -- 1 for inbound, 2 for outbound
                action SMALLINT,
                rule_id INT,
                src_ip VARCHAR(40),
                dst_ip VARCHAR(40),
                protocol SMALLINT,
                src_port INT,
                dst_port INT,
                src_country VARCHAR(10),
                dst_country VARCHAR(10),
                src_asn INT,
                dst_asn INT
            );
            """)
            self.conn.commit()
            print("'firewall_logs' table is ready.")

    def log_event(self, event_data):
        with self.conn.cursor() as cur:
            cur.execute(
                """INSERT INTO firewall_logs (machine_name, direction, action, rule_id, 
                                          src_ip, dst_ip, protocol, src_port, dst_port, 
                                          src_country, dst_country, src_asn, dst_asn)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",
                (
                    event_data['machine_name'], event_data['direction'], event_data['action'], event_data['rule_id'],
                    event_data['src_ip'], event_data['dst_ip'], event_data['protocol'], event_data['src_port'], event_data['dst_port'],
                    event_data['src_country'], event_data['dst_country'], event_data['src_asn'], event_data['dst_asn']
                )
            )
            self.conn.commit()

    def close(self):
        if self.conn:
            self.conn.close()
            print("Database connection closed.")
