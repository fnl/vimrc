from argparse import ArgumentParser
import logging
import os
import sys

from somewhere import main

__author__ = 'Florian Leitner'
__version__ = '0.0'


def parse_arguments():
    """Parse command-line with ArgumentParser and return the arguments."""

    epilog = 'system (default) encoding: {}'.format(sys.getdefaultencoding())
    parser = ArgumentParser(
        usage='%(prog)s [options] [FILE ...]',
        # description is the module's documentation
        description=__doc__, epilog=epilog,
        prog=os.path.basename(sys.argv[0])
    )

    parser.add_argument('files', metavar='FILE', nargs='*', type=open,
                        help='input file(s); if absent, read from <STDIN>')
    # parser.add_argument('--flag', action='store_true',
    #                     help='some flag to add')
    # parser.add_argument('--option', type=int, default='10',
    #                     help='some option value [%(default)s]')
    parser.add_argument('--version', action='version', version=__version__)
    parser.add_argument('--verbose', '-v', action='count', default=0,
                        help='increase log level [WARN]')
    parser.add_argument('--quiet', '-q', action='count', default=0,
                        help='decrease log level [WARN]')
    parser.add_argument('--logfile', metavar='FILE',
                        help='log to file instead of <STDERR>')

    return parser.parse_args()


def configure_logging(args):
    """Logging setup with ArgumentParser `args`."""

    msg_format = '%(levelname)-8s %(module) 10s: %(funcName)s %(message)s'
    log_adjust = max(min(args.quiet - args.verbose, 2), -2) * 10
    logging.basicConfig(
            filename=args.logfile,
            level=logging.WARNING + log_adjust,
            format=msg_format)
    logging.info('verbosity increased')
    logging.debug('verbosity increased')


if __name__ == '__main__':
    args = parse_arguments()
    configure_logging(args)
    files = args.files if args.files else [sys.stdin]

    for input_stream in files:
        try:
            main(input_stream)
        except:
            logging.exception("unexpected exception")
            parser.error("aborting after unexpected error")
