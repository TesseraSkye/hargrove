from smbus2 import SMBus

def main():
    bus = SMBus(1)
    b = bus.read_byte_data(0x30,0)
    print(b)
    bus.close()

if __name__ == "__main__":
    main()
