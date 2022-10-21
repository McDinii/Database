import math

#  key generation
n = 0


def func():
    # compute Euler function
    P = int(input("Enter an integer (P): "))
    Q = int(input("Enter an integer (Q): "))
    global n
    n = P * Q
    return (P - 1) * (Q - 1)


print(f" Product module = {n}")
F = func()
print(f"Compute Euler func F(n)=(p-1)*(Q-1) = {F}")


def compute_pk():
    #  Compute public exp
    global pk
    pk = 0
    i = 2
    while i < F:
        e = math.gcd(F, i)
        if e == 1:
            pk = i
            public = {pk, n}
            print(f"Public exp = {pk}")
            print(f"Publish {public}")
            break
        i += 1


def compute_prk():
    #  compute private exp
    i = 2
    while i < n:
        if (i * pk) % F == 1:
            global prk
            prk = i
            save = {prk, n}
            print(f"Private exp = {prk}")
            print(f"Save {save}")
            break
        i += 1


def encrypter(mes):
    compute_pk()
    #  encryption
    c = (mes ** pk) % n
    print(f"Cipher: {c} for text: {mes}")


def decrypter(crpt):
    compute_pk()
    compute_prk()
    #  decryption
    ames = (crpt ** prk) % n
    print(f"Text: {ames} for cipher {crpt}")


while True:

    action = input(
        """Choose what u want to do:
              For coding enter: 1 
              For decoding enter: 2
              For exit enter: ex
              : """)
    if action == "1":
        # request text for encryption
        mes = int(input("Enter a message u want to encrypt: "))
        encrypter(mes)
    elif action == "2":
        # request cipher for decryption
        cryption = int(input("Enter a message u want to decrypt: "))
        decrypter(cryption)
    elif action == "ex":
        break
