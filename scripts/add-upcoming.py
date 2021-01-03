import sys, os


while True:
    name = input("Tournament short name: ")
    div = input("Tournament division (i.e. B or C): ")
    link = input("URL to website: ")
    date = input("Start date of tournament (yyyy-mm-dd): ")
    with open(os.path.join(os.path.dirname(sys.argv[0]), "../data/upcoming.yaml"), "a") as fil:
        fil.write("\n")
        fil.write(f"- name: {name} (Div. {div})")
        fil.write("\n")
        fil.write(f"  link: {link}")
        fil.write("\n")
        fil.write(f"  date: {date}")
        fil.write("\n")
        new_name = name.lower().replace(" ", "_")
        fil.write(f"  file: {date}_{new_name}_{div.lower()}")
        fil.write("\n")
    print(f"Wrote {name} to file!")