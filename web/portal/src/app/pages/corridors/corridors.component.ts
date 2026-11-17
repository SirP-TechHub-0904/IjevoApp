import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

interface CorridorInfo {
  country: string;
  currency: string;
  symbol: string;
  speed: string;
  fee: string;
  payoutMethods: string[];
  link?: string;
}

@Component({
  selector: 'app-corridors',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './corridors.component.html'
})
export class CorridorsComponent {
  protected readonly corridors: CorridorInfo[] = [
    {
      country: 'Nigeria',
      currency: 'NGN',
      symbol: '₦',
      speed: 'Under 60 seconds',
      fee: '£0.00 Fee',
      payoutMethods: ['All Nigerian Commercial Banks', 'Kuda Bank', 'OPay', 'PalmPay'],
      link: '/send-money/nigeria'
    },
    {
      country: 'Ghana',
      currency: 'GHS',
      symbol: 'GH₵',
      speed: 'Instant (1-2 mins)',
      fee: '£0.00 Fee',
      payoutMethods: ['MTN Mobile Money', 'Vodafone / Telecel Cash', 'AirtelTigo', 'Bank Deposit']
    },
    {
      country: 'Kenya',
      currency: 'KES',
      symbol: 'KSh',
      speed: 'Instant (Under 60s)',
      fee: '£0.00 Fee',
      payoutMethods: ['M-Pesa Mobile Wallets', 'Equity Bank', 'KCB', 'Co-operative Bank']
    },
    {
      country: 'Argentina',
      currency: 'ARS',
      symbol: '$',
      speed: 'Within 2 hours',
      fee: 'Competitive Rate',
      payoutMethods: ['Direct CBU / CVU Bank Transfers', 'Mercado Pago']
    },
    {
      country: 'Philippines',
      currency: 'PHP',
      symbol: '₱',
      speed: 'Instant',
      fee: '£0.00 Fee',
      payoutMethods: ['GCash', 'Maya', 'BDO', 'BPI', 'Metrobank']
    },
    {
      country: 'India',
      currency: 'INR',
      symbol: '₹',
      speed: 'Instant via IMPS / UPI',
      fee: '£0.00 Fee',
      payoutMethods: ['UPI ID Direct Transfer', 'HDFC Bank', 'ICICI Bank', 'SBI']
    }
  ];
}
