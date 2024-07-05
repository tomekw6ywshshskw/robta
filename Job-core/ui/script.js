document.addEventListener("DOMContentLoaded", function () {
    const startJobButton = document.getElementById("start-job");
    const endJobButton = document.getElementById("end-job");
    const closeUIButton = document.getElementById("close-ui");
    const jobStatus = document.getElementById("job-status");

    startJobButton.addEventListener("click", function () {
        mp.trigger("startWarehouseJob");
    });

    endJobButton.addEventListener("click", function () {
        mp.trigger("endWarehouseJob");
    });

    closeUIButton.addEventListener("click", function () {
        mp.trigger("closeWarehouseJobUI");
    });

    function updateJobStatus(status) {
        jobStatus.textContent = status;
    }

    // Listen for updates from the server
    mp.events.add("updateJobStatus", updateJobStatus);
});
