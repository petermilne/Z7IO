# Copyright (c) 2021 Deutsches Elektronen-Synchrotron DESY

import argparse
import logging

import spidev

LEVEL_TRACE = logging.DEBUG - 5
logging.addLevelName(LEVEL_TRACE, "TRACE")


class CpldSpiDriver:

    Z7IO_SPI_BUS = 3
    Z7IO_CPLD_SPI_DEV = 0

    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.logger.log(LEVEL_TRACE, "SPI_BUS {} SPI_DEV {}".format(self.Z7IO_SPI_BUS, self.Z7IO_CPLD_SPI_DEV))

        self.dev = spidev.SpiDev()       
        self.dev.open(self.Z7IO_SPI_BUS, self.Z7IO_CPLD_SPI_DEV)
        self.dev.max_speed_hz = 25000000


    def rd(self, addr: int):
        to_send = [0x80 + addr, 0x00]
        """ Read a single byte """
        b = self.dev.xfer(to_send)
        data = b[1]
        self.logger.log(LEVEL_TRACE, "read: addr = %02x, data = %02x", addr, data)
        return data

    def wr(self, addr: int, val: int):
        to_send = [0x00 + addr, val]
        """ Write a single byte """
        self.dev.xfer(to_send)
        self.logger.log(LEVEL_TRACE, "write: addr = %02x, data = %02x", addr, val)
