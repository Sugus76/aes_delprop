window.addEventListener("message", (event) => {
  console.log("NUI Event Received:", event.data);

  const uiBox = document.getElementById("ui-box");
  if (event.data.type === "open") {
    uiBox.classList.remove("hidden");
    console.log("UI is now visible");
  } else if (event.data.type === "close") {
    uiBox.classList.add("hidden");
    console.log("UI is now hidden");
  }
});

document.getElementById("deletePropBtn").addEventListener("click", () => {
  document.getElementById("clickSound").play();
  fetch(`https://${GetParentResourceName()}/deleteProp`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({})
  });
});

document.getElementById("closeBtn").addEventListener("click", () => {
  document.getElementById("closeSound").play();
  fetch(`https://${GetParentResourceName()}/closeUI`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({})
  });
});
