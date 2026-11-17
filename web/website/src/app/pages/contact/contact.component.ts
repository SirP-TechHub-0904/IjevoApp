import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-contact',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './contact.component.html'
})
export class ContactComponent {
  protected readonly isSubmitted = signal(false);
  protected readonly fullName = signal('');
  protected readonly email = signal('');
  protected readonly subject = signal('General Inquiry');
  protected readonly message = signal('');

  protected onSubmit(): void {
    if (this.fullName() && this.email() && this.message()) {
      this.isSubmitted.set(true);
    }
  }
}
