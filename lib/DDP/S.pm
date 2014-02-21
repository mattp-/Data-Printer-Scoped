package DDP::S;
use strict;
use warnings;

use Data::Printer::Scoped ();
use Import::Into;

sub import {
  Data::Printer::Scoped->import::into(scalar caller);
}

1;
