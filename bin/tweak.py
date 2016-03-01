#!/usr/bin/env python

from pandocfilters import toJSONFilter, Emph, Para

def behead(key, value, format, meta):
  if key == 'Header' and value[0] >= 2:
    return Para([Emph(value[2])])

if __name__ == "__main__":
  toJSONFilter(behead)
