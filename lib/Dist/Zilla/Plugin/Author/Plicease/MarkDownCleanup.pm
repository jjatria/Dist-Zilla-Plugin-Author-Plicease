package Dist::Zilla::Plugin::Author::Plicease::MarkDownCleanup;

use 5.008001;
use Path::Class qw( dir );
use Moose;

# ABSTRACT: add a travis status button to the README.md file
# VERSION

=head1 SYNOPSIS

 [Author::Plicease::TravisStatus]

=cut

with 'Dist::Zilla::Role::AfterBuild';

has travis_status => (
  is => 'ro',
);

has travis_user => (
  is      => 'ro',
  default => 'plicease',
);

has appveyor => (
  is  => 'ro',
  isa => 'Str',
);

sub after_build
{
  my($self) = @_;
  my $readme = dir($self->zilla->root)->file("README.md");
  if(-r $readme)
  {
    my $name = $self->zilla->root->absolute->basename;
    my $user = $self->travis_user;
    
    my $status = '';
    $status .= " [![Build Status](https://secure.travis-ci.org/$user/$name.png)](http://travis-ci.org/$user/$name)" if $self->travis_status;
    $status .= " [![Build status](https://ci.appveyor.com/api/projects/status/@{[ $self->appveyor ]}/branch/master?svg=true)](https://ci.appveyor.com/project/$user/$name/branch/master)" if $self->appveyor;
    
    my $content = $readme->slurp;
    $content =~ s{# NAME\s+(.*?) - (.*?#)}{# $1$status\n\n$2}s;
    $content =~ s{# VERSION\s+version (\d+\.|)\d+\.\d+(\\_\d+|)\s+#}{#};
    $readme->spew($content);
  }
  else
  {
    $self->log("no README.md found");
  }
}

__PACKAGE__->meta->make_immutable;

1;

=head1 SEE ALSO

=over 4

=item L<Dist::Zilla>

=item L<Dist::Zilla::PluginBundle::Author::Plicease>

=back
