import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "message"]

  //フォーム送信時に呼び出す
  show(){
    this.buttonTarget.disabled = true;
    this.buttonTarget.value = "生成中...";
    this.buttonTarget.classList.add("opacity-70", "cursor-not-allowed");

    this.messageTarget.classList.remove("hidden");
    this.messageTarget.classList.add("flex");
  }
}