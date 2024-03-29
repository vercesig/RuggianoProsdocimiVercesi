import rethinkdb as r
import hashlib
from json import load
import rt_server


def registration(user):
    hash_pass = hashlib.md5(user["password"].encode())
    user["password"] = hash_pass.hexdigest()
    return save_user(user)


# set the base vehicle preference for the users,this preference are in the file basic_preference.json
def set_preference(email):
    file = open("resource/basic_preference.json", 'r')
    preference = load(file)
    r.table("user").get(email).update({"preference": preference}).run()
    file.close()


def save_user(user):
    r.connect(rt_server.ip, rt_server.port, rt_server.db_name).repl()
    # if the user mail is not already in the db save the new user and return ok
    if r.table("user").filter(r.row["email"].eq(user["email"])).count().run() == 0:
        r.table("user").insert(user).run()
        set_preference(user["email"])
        return "ok"
    else:
        return "email already registered"
