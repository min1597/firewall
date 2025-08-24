import geoip2.database
import os

class GeoIPLookup:
    def __init__(self, country_db_path="GeoLite2-Country.mmdb", asn_db_path="GeoLite2-ASN.mmdb"):
        self.country_reader = None
        self.asn_reader = None

        if os.path.exists(country_db_path):
            try:
                self.country_reader = geoip2.database.Reader(country_db_path)
                print(f"Successfully loaded GeoIP Country database from {country_db_path}")
            except Exception as e:
                print(f"Could not load GeoIP Country database: {e}")
        else:
            print(f"Warning: GeoIP Country database not found at {country_db_path}")

        if os.path.exists(asn_db_path):
            try:
                self.asn_reader = geoip2.database.Reader(asn_db_path)
                print(f"Successfully loaded GeoIP ASN database from {asn_db_path}")
            except Exception as e:
                print(f"Could not load GeoIP ASN database: {e}")
        else:
            print(f"Warning: GeoIP ASN database not found at {asn_db_path}")

    def lookup(self, ip_address):
        country = None
        asn = None
        
        if self.country_reader:
            try:
                response = self.country_reader.country(ip_address)
                country = response.country.iso_code
            except geoip2.errors.AddressNotFoundError:
                pass # IP not in database
            except Exception as e:
                print(f"GeoIP Country lookup error: {e}")

        if self.asn_reader:
            try:
                response = self.asn_reader.asn(ip_address)
                asn = response.autonomous_system_number
            except geoip2.errors.AddressNotFoundError:
                pass # IP not in database
            except Exception as e:
                print(f"GeoIP ASN lookup error: {e}")

        return country, asn

    def close(self):
        if self.country_reader:
            self.country_reader.close()
        if self.asn_reader:
            self.asn_reader.close()
