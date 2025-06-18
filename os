// save as currentOp2csv.js and run:  mongosh admin currentOp2csv.js > currentOp.csv
print("opid,type,ns,host,locks,waitingForLock,secs_running,command");

db.currentOp().inprog.forEach(op => {
  if ((op.secs_running || 0) > 60) {

    const csvLine = [
      op.opid              ?? "NA",
      op.type              ?? "NA",
      op.ns                ?? "NA",
      op.host              ?? "NA",
      op.locks ? JSON.stringify(op.locks) : "NA",
      (op.waitingForLock !== undefined ? op.waitingForLock : "NA"),
      op.secs_running      ?? "NA",
      op.command ? JSON.stringify(op.command).slice(0,500) : "NA"
    ]
    .map(v => String(v).replace(/[\r\n]+/g," "))   // keep it one line
    .join(",");

    print(csvLine);
  }
});
