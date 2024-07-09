document.addEventListener("DOMContentLoaded", function () {
    const startJobButton = document.getElementById("start-job");
    const endJobButton = document.getElementById("end-job");
    const closeUIButton = document.getElementById("close-ui");

    startJobButton.addEventListener("click", function () {
        mp.trigger("startWarehouseJob");
    });

    endJobButton.addEventListener("click", function () {
        mp.trigger("endWarehouseJob");
    });

    closeUIButton.addEventListener("click", function () {
        mp.trigger("closeWarehouseJobUI");
    });

    mp.events.add("updateJobUI", function (isOnJob) {
        if (isOnJob) {
            startJobButton.style.display = "none";
            endJobButton.style.display = "block";
        } else {
            startJobButton.style.display = "block";
            endJobButton.style.display = "none";
        }
    });
});
