#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\e[31m'
NC='\033[0m' # No Color (Reset)

# Check ROS distro
expected_ros="jazzy"

if [[ "$ROS_DISTRO" == "$expected_ros" ]]; then 
    echo -e "${GREEN}[PASS]${NC} ROS Jazzy Jalisco confirmed."
else
    echo -e "${RED}[FAIL] Expected ROS_DISTRO=${expected_ros}, got ${ROS_DISTRO}.${NC}"
    exit 1
fi

# Check Ubuntu version
expected_ubuntu="Ubuntu 24.04"
source /etc/os-release
actual_ubuntu_distribution="$NAME"
actual_ubuntu_version="$VERSION_ID"
actual_ubuntu="${actual_ubuntu_distribution} ${actual_ubuntu_version}"

if [[ "$actual_ubuntu" == "$expected_ubuntu" ]]; then 
    echo -e "${GREEN}[PASS]${NC} ${expected_ubuntu} confirmed."
else
    echo -e "${RED}[FAIL] Expected ${expected_ubuntu}, got ${actual_ubuntu}.${NC}"
    exit 1
fi


# Check Python version
expected_python="3.12"
actual_python_major="$(python3 -c 'import sys; print(sys.version_info.major)')"
actual_python_minor="$(python3 -c 'import sys; print(sys.version_info.minor)')"

if [[ "${actual_python_major}.${actual_python_minor}" == "$expected_python" ]]; then
    echo -e "${GREEN}[PASS]${NC} Python ${expected_python} confirmed."
else 
    echo -e "${RED}[FAIL] Expected ${expected_python}, got ${actual_python_major}.${actual_python_minor}.${NC}"
    exit 1
fi

# Check gcc version
expected_gcc_family="13"
actual_gcc_family="$(gcc -dumpversion)"
if [[ "$actual_gcc_family" == "$expected_gcc_family" ]]; then
    echo -e "${GREEN}[PASS]${NC} gcc ${expected_gcc_family} confirmed."
else 
    echo -e "${RED}[FAIL] Expected ${expected_gcc_family}, got ${actual_gcc_family}.${NC}"
    exit 1
fi

# Confirm presence of g++, git, cmake, and colcon
REQUIRED_DEPENDENCIES=(g++ git cmake colcon)

confirm_dependency_present() {
    dependency="$1"
    dependency_status="$(command -v $dependency)"
    if [[ -z "$dependency_status" ]]; then
        echo "${RED}[FAIL] ${dependency} not found.${NC}"
        exit 1
    else 
        echo -e "${GREEN}[PASS]${NC} ${dependency} confirmed."
    fi
}

for dep in "${REQUIRED_DEPENDENCIES[@]}"; do
    confirm_dependency_present $dep
done

# Verify uv version
expected_uv="0.12.19"
actual_uv="$(uv self version --short)"

if [[ "$actual_uv" == "$expected_uv" ]]; then
    echo -e "${GREEN}[PASS]${NC} uv ${expected_uv} confirmed."
else
    echo -e "${RED}[FAIL] expected uv ${expected_uv}, got ${actual_uv}${NC}."
    exit 1
fi

# Verify ruff version
expected_ruff="ruff 0.16.9"
actual_ruff="$(ruff --version)"

if [[ "$actual_ruff" == "$expected_ruff" ]]; then
    echo -e "${GREEN}[PASS]${NC} ${expected_ruff} confirmed."
else 
    echo -e "${RED}[FAIL] expected ${expected_ruff}, got ${actual_ruff}${NC}."
    exit 1
fi

# Verify pyright version
expected_pyright="pyright 1.1.414"
actual_pyright="$(pyright --version)"

if [[  "$actual_pyright" == "$expected_pyright" ]]; then
    echo -e "${GREEN}[PASS]${NC} ${expected_pyright} confirmed."
else 
    echo -e "${RED}[FAIL] expected ${expected_pyright}, got ${actual_pyright}${NC}."
    exit 1
fi 

# 

exit -1