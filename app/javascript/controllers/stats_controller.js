import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'teamOneGoals'
  ];

  connect() {
    console.log('hoi')
  }
}
