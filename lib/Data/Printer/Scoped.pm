package Data::Printer::Scoped;
# ABSTRACT:  silence Data::Printer except in a controlled scope

use strict;
use warnings;

use Data::Printer ();
use Class::Method::Modifiers qw(:all);
use Sub::Exporter::Progressive -setup => {
  exports => [qw(scope)],
  groups => { default => [qw(scope)] },
};

our $enabled = 0;

install_modifier('Data::Printer', 'around', '_print_and_return', sub {
  my $orig = shift;

  # noop unless enabled.
  return $enabled ? $orig->(@_) : ();
});

# we only blanket disable Data::Printer if a scope() call has been made.
sub scope(&) {
  my ($code) = @_;

  $enabled = 1;
  my @ret = $code->();
  $enabled = 0;

  return @ret;
}

1;

__END__

=pod

=encoding UTF-8

=head1 SYNOPSIS

Sometimes you want to stick a dumper statement on a very hot codepath, but you
are interested in the output of your specific invocation. Often times this is
in the middle of a test. To narrow down when and what gets dumped, you can just
do this:

  use Data::Printer::Scoped qw/scope/;

  scope {
    do_something();
  };

  # elsewhere deep in another package
  sub some_hot_codepath {
    use Data::Printer;
    p $foo;
  }


=head1 PROVIDED FUNCTIONS

=over 4

=item B<scope(&)>

Takes a single code block, and runs it. Before running, the overridden print
method of Data::Printer will be enabled, and disabled afterward.

=back

=cut
