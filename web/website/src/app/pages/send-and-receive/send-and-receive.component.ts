import { Component, computed, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';

interface PayoutCurrency {
  code: string;
  name: string;
  ratePerGbp: number;
  symbol: string;
}

@Component({
  selector: 'app-send-and-receive',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './send-and-receive.component.html',
  styleUrls: ['./send-and-receive.component.scss']
})
export class SendAndReceiveComponent {
  protected readonly sendAmount = signal<number>(500);
  protected readonly sendCurrency = signal<string>('GBP');
  protected readonly receiveCurrency = signal<string>('NGN');

  // Custom Dropdown Open States
  protected readonly isSendDropdownOpen = signal<boolean>(false);
  protected readonly isReceiveDropdownOpen = signal<boolean>(false);

  // Supported Send Currencies (USD, EUR, GBP)
  protected readonly sendCurrencies = [
    { code: 'GBP', name: 'United Kingdom (GBP)', short: 'UK (GBP)', symbol: '£', rateMultiplier: 1.0 },
    { code: 'USD', name: 'United States (USD)', short: 'USA (USD)', symbol: '$', rateMultiplier: 0.785 },
    { code: 'EUR', name: 'Eurozone (EUR)', short: 'Euro (EUR)', symbol: '€', rateMultiplier: 0.855 }
  ];

  // Supported Payout Corridors
  protected readonly payoutCurrencies: PayoutCurrency[] = [
    { code: 'NGN', name: 'Nigeria (NGN)', ratePerGbp: 1846.00, symbol: '₦' },
    { code: 'KES', name: 'Kenya (KES)', ratePerGbp: 168.50, symbol: 'KSh' },
    { code: 'GHS', name: 'Ghana (GHS)', ratePerGbp: 19.80, symbol: 'GH₵' },
    { code: 'ZAR', name: 'South Africa (ZAR)', ratePerGbp: 23.20, symbol: 'R' },
    { code: 'RWF', name: 'Rwanda (RWF)', ratePerGbp: 1740.00, symbol: 'FRw' },
    { code: 'PHP', name: 'Philippines (PHP)', ratePerGbp: 74.20, symbol: '₱' },
    { code: 'INR', name: 'India (INR)', ratePerGbp: 108.40, symbol: '₹' }
  ];

  // Selected Send Currency Details
  protected readonly selectedSendCurrency = computed(() => {
    return this.sendCurrencies.find(c => c.code === this.sendCurrency()) || this.sendCurrencies[0];
  });

  // Selected Receive Currency Details
  protected readonly selectedCurrency = computed(() => {
    const found = this.payoutCurrencies.find(c => c.code === this.receiveCurrency());
    return found || this.payoutCurrencies[0];
  });

  // Computed Exchange Rate
  protected readonly currentRate = computed(() => {
    const mult = this.selectedSendCurrency().rateMultiplier;
    return Math.round(this.selectedCurrency().ratePerGbp * mult * 100) / 100;
  });

  // Computed Payout Total
  protected readonly calculatedPayout = computed(() => {
    const total = this.sendAmount() * this.currentRate();
    return total.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  });

  protected toggleSendDropdown(event?: Event): void {
    if (event) event.stopPropagation();
    this.isReceiveDropdownOpen.set(false);
    this.isSendDropdownOpen.update(v => !v);
  }

  protected toggleReceiveDropdown(event?: Event): void {
    if (event) event.stopPropagation();
    this.isSendDropdownOpen.set(false);
    this.isReceiveDropdownOpen.update(v => !v);
  }

  protected selectSendCurrency(code: string, event?: Event): void {
    if (event) event.stopPropagation();
    this.sendCurrency.set(code);
    this.isSendDropdownOpen.set(false);
  }

  protected selectReceiveCurrency(code: string, event?: Event): void {
    if (event) event.stopPropagation();
    this.receiveCurrency.set(code);
    this.isReceiveDropdownOpen.set(false);
  }

  protected closeDropdowns(): void {
    this.isSendDropdownOpen.set(false);
    this.isReceiveDropdownOpen.set(false);
  }

  protected updateSendAmount(val: number): void {
    this.sendAmount.set(val > 0 ? val : 1);
  }

  protected setSendCurrency(code: string): void {
    this.sendCurrency.set(code);
  }

  protected setReceiveCurrency(code: string): void {
    this.receiveCurrency.set(code);
  }
}
