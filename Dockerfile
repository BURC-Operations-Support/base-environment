# syntax=docker/dockerfile:1

FROM ros:lyrical-ros-base-resolute

SHELL ["/bin/bash", "-c"]

COPY ./scripts/verify-platform.sh /usr/local/bin/verify-platform.sh

COPY --from=ghcr.io/astral-sh/uv:0.12.19 /uv /uvx /usr/local/bin/

# Centrally managed Python quality tooling
# Project-specific Python config may differ
ENV UV_TOOL_DIR="/opt/burc/tools" \
    UV_TOOL_BIN_DIR="/usr/local/bin"

RUN uv tool install ruff==0.16.9

RUN uv tool install pyright[nodejs]==1.1.414

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgtest-dev \
        libgmock-dev \
        clang-format-18 \
        clang-tidy-18 \
        gdb \
    && rm -rf /var/lib/apt/lists/*

# Next item: Pytest versioning
# Nothing actually happens until you've figured out the deployment model and build checker, though
# Need high-level CMBE architecture first 

RUN /usr/local/bin/verify-platform.sh

CMD ["bash"]