pragma solidity ^0.8.10;

contract TaskManager {
    uint256 public nTasks;

    enum TaskPhase {
        ToDo,
        InProgress,
        Done,
        Blocked,
        Review,
        Postponed,
        Canceled
    }

    struct TaskStruct {
        address owner;
        string name;
        TaskPhase phase;
        uint256 priority;
    }

    TaskStruct[] private tasks;

    mapping(address => uint256[]) private myTasks;

    event TaskAdded(
        address owner,
        string name,
        TaskPhase phase,
        uint256 priority
    );

    modifier onlyOwner(uint256 _taskIndex) {
        if (tasks[_taskIndex].owner == msg.sender) {
            _;
        }
    }

    constructor() {
        nTasks = 0;
        addTask("Create Task Manager", TaskPhase.Done, 1);
        addTask("Create our first task", TaskPhase.ToDo, 1);
        addTask("Clean your house", TaskPhase.ToDo, 5);
    }

    function getTask(uint256 _taskIndex)
        public
        view
        returns (
            address owner,
            string memory name,
            TaskPhase phase,
            uint256 priority
        )
    {
        owner = tasks[_taskIndex].owner;
        name = tasks[_taskIndex].name;
        phase = tasks[_taskIndex].phase;
        priority = tasks[_taskIndex].priority;
    }

    function listMyTasks() public view returns (uint256[] memory) {
        return myTasks[msg.sender];
    }

    function addTask(
        string memory _name,
        TaskPhase _phase,
        uint256 _priority
    ) public returns (uint256 index) {
        require(
            (_priority >= 1 && _priority <= 5),
            "priority must be between 1 and 5"
        );
        TaskStruct memory taskAux = TaskStruct({
            owner: msg.sender,
            name: _name,
            phase: _phase,
            priority: _priority
        });
        tasks.push(taskAux);
        index = tasks.length - 1;

        nTasks++;
        myTasks[msg.sender].push(index);
        emit TaskAdded(msg.sender, _name, _phase, _priority);
    }

    function updatePhase(uint256 _taskIndex, TaskPhase _phase)
        public
        onlyOwner(_taskIndex)
    {
        tasks[_taskIndex].phase = _phase;
    }
}
