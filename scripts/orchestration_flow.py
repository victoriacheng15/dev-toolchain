# /// script
# dependencies = [
#     "diagrams",
# ]
# ///

"""How to run:
    uv run orchestration_flow.py
"""

from diagrams import Diagram, Edge
from diagrams.programming.flowchart import Action, Decision, Document

graph_attr = {
    "pad": "0.2",
    "margin": "0.0",
    "ranksep": "1.2",
    "nodesep": "0.8",
}

with Diagram(
    "",
    show=False,
    filename="orchestration_flow",
    graph_attr=graph_attr,
):
    start = Action("Code Changes\nInitiated")
    load = Document("AI Agent Loads\nSKILL.md")
    execute = Action("Executes Task\nConstraints")
    gate = Decision("Verification\nGate")
    retry = Action("Fix &\nRetry")
    success = Action("Clean, Compliant\nState")

    start >> load >> execute >> gate >> Edge(label="Pass", color="darkgreen") >> success
    gate >> Edge(label="Fail", color="firebrick") >> retry
    retry >> Edge(color="firebrick", constraint="false") >> execute
