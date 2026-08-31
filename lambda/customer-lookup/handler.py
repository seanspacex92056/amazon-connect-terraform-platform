import hashlib
import json


def _tier_from_phone(phone: str) -> str:
    if not phone:
        return "STANDARD"
    bucket = int(hashlib.sha256(phone.encode("utf-8")).hexdigest(), 16) % 10
    if bucket == 0:
        return "PLATINUM"
    if bucket <= 2:
        return "GOLD"
    return "STANDARD"


def lambda_handler(event, context):
    details = event.get("Details", {})
    contact_data = details.get("ContactData", {})
    endpoint = contact_data.get("CustomerEndpoint", {})
    phone = endpoint.get("Address", "")
    tier = _tier_from_phone(phone)

    return {
        "customerId": f"OT-{phone[-4:] if phone else '0000'}",
        "supportTier": tier,
        "priority": "1" if tier == "PLATINUM" else "5",
        "accountStatus": "ACTIVE"
    }
