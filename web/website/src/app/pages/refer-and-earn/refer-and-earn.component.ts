import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-refer-and-earn',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './refer-and-earn.component.html',
  styleUrls: ['./refer-and-earn.component.scss']
})
export class ReferAndEarnComponent {
  protected readonly steps = [
    {
      num: '01',
      title: 'Download the App & Get Your Link',
      desc: 'Open the official Ijevo app on iOS or Android, go to the Refer & Earn tab, and copy your unique personal referral code.'
    },
    {
      num: '02',
      title: 'Share With Friends & Family',
      desc: 'Send your invite link via WhatsApp, SMS, or social media to anyone who sends money abroad from the UK or Europe.'
    },
    {
      num: '03',
      title: 'Both of You Earn £10 Cash',
      desc: 'Once your friend completes their first transfer of £50+, £10 is instantly credited to your wallet, and they get £10 off!'
    }
  ];

  protected readonly benefits = [
    {
      icon: 'fa-solid fa-infinity',
      title: 'No Referral Caps',
      desc: 'There is zero limit to how much you can earn. Refer 5 friends, get £50. Refer 20, get £200.'
    },
    {
      icon: 'fa-solid fa-bolt',
      title: 'Instant Cash Crediting',
      desc: 'Bonus funds land in your account the moment your friend\'s transfer delivers successfully.'
    },
    {
      icon: 'fa-solid fa-hand-holding-dollar',
      title: 'Real Cash, Not Vouchers',
      desc: 'Use your earned rewards towards your next transfer or withdraw directly to your UK bank.'
    }
  ];
}
