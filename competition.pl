#!/usr/bin/env perl

use strict;
use warnings;

# Hash Dispatch Table
my %players = (
	       titFORtat => \&titFORtat,
	       coOp => \&coOp,
	       defect => \&defect,
	       random => \&random,
	       tranquilizer => \&tranquilizer,
	       twoDefect => \&twoDefect,
	       twoCoop => \&twoCoop
	      );

# build Reward/Punishment tables
my %rewardTit = (
		 C => {C => 3, D => 0},
		 D => {C => 5, D => 1}
		);

my %rewardOpp = (
		 C => {C => 3, D => 0},
		 D => {C => 5, D => 1}
		);

# titFORtat, coOp, defect, random, tranquilizer, allowDefect/Coop
my @teams = ('titFORtat','coOp','defect','random','tranquilizer','twoDefect','twoCoop');
my $turn = 0;
my $trials = 200;
my $tranqThresh = .4;
my ($choice1,$choice2,$choice1a,$choice2a);
my ($result,$turn1d,$turn2d,$turn1c,$turn2c);
my ($score1,$score2,$scoreTot) = (0,0,0);
my ($player1, $player2);
open my $out, '>', 'score.txt';
open my $data, '>', 'data.txt';

foreach my $player1 (@teams) {
  foreach my $player2 (@teams) {
    print $out "Teams:\t$player1\t$player2\n";
    print $data "Teams:\t$player1\t$player2\n";
    foreach my $trial (1..$trials) {
      $turn++;
      $choice1 = $players{$player1}($choice2a);
      $choice2 = $players{$player2}($choice1a);
      $choice1a = $choice1;
      $choice2a = $choice2;
      $score1 = $score1 + $rewardTit{$choice1}{$choice2};
      $score2 = $score2 + $rewardOpp{$choice2}{$choice1};
      print $data "$turn\t$choice1\t$choice2\n";
    }
    $scoreTot = $scoreTot + $score1;
    print $out "Score:\t$score1\t$score2\n";
    ($score1,$score2,$turn) = (0,0,0);
  }
  print $out "$player1 total: $scoreTot\n\n";
  $scoreTot = 0;
}

print 'Trial results in data.txt, Final results in score.txt\n';


sub titFORtat
  {
    $result = shift @_;
    if ($turn == 1) {
      $result = 'C';
    }
    return $result;
  }

sub coOp
  {
    $result = 'C';
    return $result;
  }

sub defect
  {
    $result = 'D';
    return $result;
  }

sub random
  {
    my $rand = rand(1);
    if ($rand <= .5) {
      $result = 'C';
    } else {
      $result = 'D';
    }
    return $result;
  }

sub tranquilizer
  {
    my $rand = rand(1);
    if ($turn == 1) {
      $result = 'C';
    } elsif ($rand < $tranqThresh) {
      $result = 'D';
    } elsif ($rand >= $tranqThresh) {
      $result = 'C';
    }
    return $result;
  }

sub twoDefect
  {
    $turn1d = shift @_;
    if ($turn < 3) {
      $result = 'C';
    } elsif (($turn1d eq $turn2d) and ($turn1d eq 'D')) {
      $result = 'D';
    } else {
      $result = 'C';
    }
    $turn2d = $turn1d;
    return $result;
  }

sub twoCoop
  {
    $turn1c = shift @_;
    if ($turn < 3) {
      $result = 'D';
    } elsif (($turn1c eq $turn2c) and ($turn1c eq 'C')) {
      $result = 'C';
    } else {
      $result = 'D';
    }
    $turn2c = $turn1c;
    return $result;
  }
