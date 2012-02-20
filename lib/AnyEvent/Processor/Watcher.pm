package AnyEvent::Processor::Watcher;
# ABSTRACT: A watcher echoing a process messages, base class

use Moose;
use AnyEvent;


has delay   => ( is => 'rw', isa => 'Int', default => 1 );
has action  => ( is => 'rw', does => 'AnyEvent::Processor::WatchableTask' );
has stopped => ( is => 'rw', isa => 'Int', default => 0 );

has wait => ( is => 'rw' );


=method start

=cut
sub start {
    my $self = shift;

    $self->action->start_message(),
    $self->wait( AnyEvent->timer(
        after => $self->delay,
        interval => $self->delay,
        cb    => sub {
            $self->action()->process_message(),
        },
    ) );
}


=method stop

=cut
sub stop {
    my $self = shift;
    $self->action->end_message();
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

