import pysnooper


@pysnooper.snoop()
def fact(x):
    return x if x == 1 else x * fact(x - 1)


print(fact(10))
