import { Component, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-nigeria',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './nigeria.component.html'
})
export class NigeriaCorridorComponent {
  protected readonly sendAmount = signal<number>(200);
  protected readonly rate = signal<number>(1846.00);

  protected readonly calculatedNgn = computed(() => {
    const total = this.sendAmount() * this.rate();
    return total.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  });

  protected updateAmount(val: number): void {
    this.sendAmount.set(val > 0 ? val : 1);
  }

  protected readonly nigerianBanks = [
    'Access Bank', 'Guaranty Trust Bank (GTBank)', 'Zenith Bank', 'United Bank for Africa (UBA)',
    'First Bank of Nigeria', 'Stanbic IBTC', 'Fidelity Bank', 'Sterling Bank',
    'Kuda Microfinance Bank', 'OPay Digital Services', 'PalmPay', 'Moniepoint Microfinance Bank',
    'Wema Bank / ALAT', 'Union Bank', 'Ecobank Nigeria', 'FCMB'
  ];
}
