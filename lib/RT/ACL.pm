

# $Header$
# Autogenerated by DBIx::SearchBuilder factory  (by <jesse@fsck.com>)

=head1 NAME

  RT::ACL -- Class Description
 
=head1 SYNOPSIS

  use RT::ACL

=head1 DESCRIPTION


=head1 METHODS

=cut

package RT::ACL;

use RT::SearchBuilder;
use RT::ACE;

@ISA= qw(RT::SearchBuilder);


sub _Init {
    my $self = shift;
    $self->{'table'} = 'ACL';
    $self->{'primary_key'} = 'id';
    return ( $self->SUPER::_Init(@_) );
}


=item NewItem

Returns an empty new RT::ACE item

=cut

sub NewItem {
    my $self = shift;
    return(new RT::ACE(@_));
}

        eval "require RT::ACL_Overlay";
        if ($@ && $@ !~ /^Can't locate/) {
            die $@;
        };

        eval "require RT::ACL_Local";
        if ($@ && $@ !~ /^Can't locate/) {
            die $@;
        };




=head1 SEE ALSO

This class allows "overlay" methods to be placed
into the following files _Overlay is for a System overlay by the original author,
while _Local is for site-local customizations.  

These overlay files can contain new subs or subs to replace existing subs in this module.

If you'll be working with perl 5.6.0 or greater, each of these files should begin with the line 

   no warnings qw(redefine);

so that perl does not kick and scream when you redefine a subroutine or variable in your overlay.

RT::ACL_Overlay, RT::ACL_Local

=cut


1;
