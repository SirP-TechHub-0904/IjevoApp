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
  templateUrl: './send-and-receive.component.html'
})
export class SendAndReceiveComponent {
  protected readonly sendAmount = signal<number>(500);
  protected readonly receiveCurrency = signal<string>('NGN');

  protected readonly payoutCurrencies: PayoutCurrency[] = [
    { code: 'NGN', name: 'Nigerian Naira', ratePerGbp: 1846.00, symbol: '₦' },
    { code: 'KES', name: 'Kenyan Shilling', ratePerGbp: 168.50, symbol: 'KSh' },
    { code: 'GHS', name: 'Ghanaian Cedi', ratePerGbp: 19.80, symbol: 'GH₵' },
    { code: 'ARS', name: 'Argentine Peso', ratePerGbp: 2042.99, symbol: '$' },
    { code: 'PHP', name: 'Philippine Peso', ratePerGbp: 74.20, symbol: '₱' },
    { code: 'INR', name: 'Indian Rupee', ratePerGbp: 108.40, symbol: '₹' }
  ];

  protected readonly selectedCurrency = computed(() => {
    const found = this.payoutCurrencies.find(c => c.code === this.receiveCurrency());
    return found || this.payoutCurrencies[0];
  });

  protected readonly currentRate = computed(() => this.selectedCurrency().ratePerGbp);

  protected readonly calculatedPayout = computed(() => {
    const total = this.sendAmount() * this.currentRate();
    return total.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  });

  protected updateSendAmount(val: number): void {
    this.sendAmount.set(val > 0 ? val : 1);
  }

  protected setReceiveCurrency(code: string): void {
    this.receiveCurrency.set(code);
  }
}
