import pywhatkit

def send_single_message(phone_number, message, hour, minute):
    try:
        pywhatkit.sendwhatmsg(phone_number, message, hour, minute)
        print("Message sent successfully!")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

def sms_bomber(phone_number, message, hour, minute, times_to_spam):
    try:
        for _ in range(times_to_spam):
            pywhatkit.sendwhatmsg(phone_number, message, hour, minute)
        print(f"{times_to_spam} messages sent successfully!")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

def main():
    print("WhatsApp Message Sender")
    phone_number = input("Enter phone number (with country code, e.g., +1234567890): ")
    message = input("Enter message: ")
    hour = int(input("Enter hour (24-hour format): "))
    minute = int(input("Enter minute: "))

    choice = input("Do you want to send multiple messages? (yes/no): ").strip().lower()

    if choice == "yes":
        times_to_spam = int(input("Enter how many times to spam: "))
        sms_bomber(phone_number, message, hour, minute, times_to_spam)
    else:
        send_single_message(phone_number, message, hour, minute)

if __name__ == "__main__":
    main()
