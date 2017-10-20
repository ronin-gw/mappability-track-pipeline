import argparse


class VStepWigFilter(object):
    def __init__(self, score, output_as_bedgraph=False):
        self.threshold = score
        if output_as_bedgraph:
            self._print_track = self._print_bg_track
        else:
            self._print_track = self._print_wigvs_track

        self._spanlen = None
        self._track_buff = []
        self._current_chr = None

    def _init_chrom_pos(self, chrom):
        self._last_pos = 1
        self._cum_spanlen = 0
        self._current_chr = chrom

    def filtering(self, path):
        with open(path) as f:
            for l in f:
                l = l.rstrip('\n')

                if l.startswith('v'):
                    self._read_header(l)
                else:
                    self._read_track(l)
        self._pop_and_print_buff()

    def _print_wigvs_track(self, spanlen, pos, score):
        if spanlen == 1:
            print "variableStep\t" + self._current_chr
        else:
            print "variableStep\t{}\tspan={}".format(self._current_chr, spanlen)
        print "{}\t{}".format(pos, score)

    def _print_bg_track(self, spanlen, pos, score):
        zero_based_pos = int(pos) - 1
        print self._current_chr[6:] + "\t{}\t{}\t{}".format(zero_based_pos, zero_based_pos + spanlen, score)

    def _pop_and_print_buff(self):
        for pos, score in self._track_buff:
            if float(score) >= self.threshold:
                if self._cum_spanlen:
                    self._print_track(self._cum_spanlen, self._last_pos, 0)
                self._print_track(self._spanlen, pos, score)
                self._last_pos = int(pos) + self._spanlen
                self._cum_spanlen = 0
            else:
                self._cum_spanlen += self._spanlen

    def _read_header(self, l):
        self._pop_and_print_buff()

        head = l.split('\t')[1:]
        if len(head) == 2:
            chrom, span = head
            self._spanlen = int(span[5:])
        else:
            chrom = head[0]
            self._spanlen = 1

        self._track_buff = []
        if chrom != self._current_chr:
            self._init_chrom_pos(chrom)

    def _read_track(self, l):
        self._track_buff.append(l.split('\t'))


def _main():
    p = argparse.ArgumentParser()
    p.add_argument("-s", "--score", type=float, default=1.)
    p.add_argument("--bedgraph", action="store_true")
    p.add_argument("path")
    args = p.parse_args()

    fil = VStepWigFilter(args.score, args.bedgraph)
    fil.filtering(args.path)


if __name__ == "__main__":
    _main()
