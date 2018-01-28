import requests
from requests.auth import HTTPBasicAuth
import json
from ast import literal_eval
import random
import string


def get_answer_status_code(answer):
    """
    The function gets requested data and returns status code.
    :param answer: Requested data
    :return: Status code
    """
    return answer.status_code


def create_address(site, *args):
    """
    Adds link(s) to site address.
    If parameter 'auth' in arguments the function changes
    string building.
    :param site: Site name
    :param args: Link(s)
    :return: full site address.
    """
    if 'auth' in args:
        return site + "".join(['/' + str(link) for link in args[:-1]])
    return site + "".join([str(link) for link in args])


def check_site_availability(site_name):
    """
    This function check if site is available by Status code.
    :param site_name: Site address
    :return: None
    """
    answer = requests.get(site_name)
    if answer.status_code != 200:
        raise ConnectionError("Answer status != 200")


def send_request(site):
    """
    Sends get request to site
    :param site: Site address
    :return: Recieved data
    """
    answer = requests.get(site)
    return answer


def data_processing(answer):
    """
    Processes unprepaired data from request
    :param answer: unprepaired data
    :return:
    """
    if answer.status_code == 200:
        try:
            print(json.dumps(answer.json(), indent=4))
        except:
            for row in answer.text.split('\n')[:-1]:
                print(json.dumps(dict(literal_eval(row)), indent=4))
    else:
        print(answer.status_code)


def generate_username():
    """
    Generates username
    :return: username
    """
    symbols = string.ascii_letters + string.digits
    user = "".join([random.choice(symbols) for elem in range(random.randint(4, 15))])
    return user


def generate_password():
    """
    Generates password
    :return: password
    """
    symbols = string.ascii_letters + string.digits
    password = "".join([random.choice(symbols) for elem in range(random.randint(5, 15))])
    return password


def send_login_data(site, correct=True):
    """
    This function especially for authenticator process.
    :param site: Site address
    :param correct: If correct=True we expect successful login
    :return: auth get request
    """
    if correct:
        parts = site.split('/')
        username = parts[-2]
        password = parts[-1]
        return requests.get(site, auth=HTTPBasicAuth(username, password))
    else:
        username = generate_username()
        password = generate_password()
        return requests.get(site, auth=HTTPBasicAuth(username, password))


def generate_stream_count():
    """
    The function generates count of streams
    for streams/ link.
    :return: Count of streams
    """
    return random.randint(0, 101)


def get_headers_from_answer(answer):
    """
    The function gets 3 special headers from requested data.
    :param answer: requested data
    :return: Dictionary with 3 headers and their values.
    """
    some_headers = dict()
    some_headers['X-Powered-By'] = answer.headers['X-Powered-By']
    some_headers['Server'] = answer.headers['Server']
    some_headers['Content-Type'] = answer.headers['Content-Type']
    return some_headers


def get_number_of_streams(*args):
    """
    The function generates special int for checking different
    situations for streams/ function.
    :param args: Special flag.
    :return: Special value.
    """
    if args:
        if args[0] == 'correct':
            return random.randint(1, 100)
        elif args[0] == 'low_boundary':
            return 0
        elif args[0] == 'high_boundary':
            return 100
        elif args[0] == 'below_boundary':
            return -1
        elif args[0] == 'above_boundary':
            return 101


def get_number_of_streams_in_request(answer):
    """
    This function consider count of rows in requested data.
    :param answer: Requested data.
    :return: Count of rows.
    """
    return len(answer.text.split('\n'))-1


def send_authentication_data(site, username, password):
    """
    Function for sending auth parameters to site.
    :param site: Site Address
    :param username: Username
    :param password: Password
    :return: Answer from site
    """
    auth_answer = requests.get(site, auth=HTTPBasicAuth(username, password))
    return auth_answer
