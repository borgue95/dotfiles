import requests
import re


# seriously python does not support . instead of ,?
# setting locale does not work
def thousand_separator(n):
    r = []
    for i, c in enumerate(reversed(str(n))):
        if i and (not (i % 3)):
            r.insert(0, '.')
        r.insert(0, c)
    return ''.join(r)


def get_text_from_column(text):
    regex = "\<td\>(.*?)\<\/td\>"
    result = re.search(regex, text)
    if result is None:
        return "0"
    else:
        return result.groups()[0]


def main():
    info = requests.get("https://apps.foldingathome.org/teamstats/team223518.html")

    pattern_start = "<table class=\"members\">"
    line_pattern = "<tr>"

    lines = info.text.splitlines()
    lines = [l.strip() for l in lines]

    user_me = 'borgue95'
    me = 0

    start = -1
    i = 0
    while i < len(lines):
        if pattern_start in lines[i]:
            start = i

        if start > -1 and line_pattern in lines[i]:
            dic = dict(user=0, rank=0, team_rank=0, credit=0, WUs=0)
            i += 1
            dic['rank'] = int(get_text_from_column(lines[i]))
            i += 1
            dic['team_rank'] = int(get_text_from_column(lines[i]))
            i += 1
            dic['user'] = get_text_from_column(lines[i])
            i += 1
            dic['credit'] = int(get_text_from_column(lines[i]))
            i += 1
            dic['WUs'] = int(get_text_from_column(lines[i]))

            if dic['user'] == user_me:
                me = dic
                break

        i += 1

    # print(
    #     '{0} LMG: {1} C: {2}'.format(thousand_separator(me['rank']),
    #                                  thousand_separator(me['team_rank']),
    #                                  thousand_separator(me['credit'])))

    print(
        '{0} LMG: {1}'.format(thousand_separator(me['rank']),
                              thousand_separator(me['team_rank'])))


if __name__ == '__main__':
    main()
